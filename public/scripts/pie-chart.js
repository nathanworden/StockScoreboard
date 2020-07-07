$(function() {
  const doughCanvas = document.getElementById("allocation-canvas");
  const ctx = doughCanvas.getContext("2d");

  let colors = ['#B2ECD6', '#7077AA', '#B6BED8', '#CDD4E7', '#00D4A3', '#01A881'];
  let angles = [Math.PI * 0.3, Math.PI * 0.7, Math.PI * 0.2, Math.PI * 0.4, Math.PI * 0.4];

  let beginAngle = 0;
  let endAngle = 0;

  // Create pie chart pieces
  for (let i = 0; i < angles.length; i += 1) {
    beginAngle = endAngle;
    endAngle += angles[i];

    ctx.beginPath();
    ctx.fillStyle = colors[i % colors.length];

    ctx.moveTo(150, 150);
    ctx.arc(150, 150, 150, beginAngle, endAngle);
    ctx.lineTo(150, 150);
    ctx.fill();
  }

  // Cover center of pie with a smaller white circle
  ctx.beginPath();
  ctx.fillStyle = '#FFFFFF';
  ctx.moveTo(150, 150);
  ctx.arc(150, 150, 80, 0, 360);
  ctx.lineTo(150, 150);
  ctx.fill();
});

