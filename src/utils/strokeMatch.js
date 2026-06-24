/**
 * Computes a coverage score by comparing the user's strokes against the
 * font-rendered reference character. Both are drawn to off-screen canvases
 * and their pixels are compared.
 *
 * @param {string} character - The Devanagari character to compare against.
 * @param {Array<{points: {x:number,y:number}[]}>} strokes - User-drawn strokes.
 * @returns {number} Coverage ratio 0–1.
 */
export function computeCoverage(character, strokes) {
  const res = 200

  const refCanvas = document.createElement('canvas')
  refCanvas.width = res
  refCanvas.height = res
  const refCtx = refCanvas.getContext('2d')
  refCtx.font = `${Math.round(res * 0.67)}px serif`
  refCtx.textAlign = 'center'
  refCtx.textBaseline = 'middle'
  refCtx.fillStyle = '#000'
  refCtx.fillText(character, res / 2, res / 2 + 3)
  const refData = refCtx.getImageData(0, 0, res, res).data

  const userCanvas = document.createElement('canvas')
  userCanvas.width = res
  userCanvas.height = res
  const userCtx = userCanvas.getContext('2d')
  userCtx.strokeStyle = '#000'
  userCtx.lineWidth = 4
  userCtx.lineCap = 'round'
  userCtx.lineJoin = 'round'
  strokes.forEach((s) => {
    if (s.points.length < 2) return
    userCtx.beginPath()
    userCtx.moveTo(s.points[0].x * res, s.points[0].y * res)
    for (let i = 1; i < s.points.length; i++) {
      userCtx.lineTo(s.points[i].x * res, s.points[i].y * res)
    }
    userCtx.stroke()
  })
  const userData = userCtx.getImageData(0, 0, res, res).data

  let refPixels = 0
  let covered = 0
  for (let i = 3; i < refData.length; i += 4) {
    if (refData[i] > 50) {
      refPixels++
      if (userData[i] > 50) covered++
    }
  }
  return refPixels > 0 ? covered / refPixels : 0
}
