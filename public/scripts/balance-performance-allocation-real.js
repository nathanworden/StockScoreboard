$(function() {
  let balancesTable = document.getElementById('the-actual-yield');

  let optionHeading = document.querySelector('.option-heading');
  optionHeading.addEventListener('click', function(event) {
    let h5s = event.currentTarget.children;
    h5s = [].slice.call(h5s);
    h5s.forEach(h5 => {
      h5.classList.remove('active');
    })
    event.target.classList.add('active');

    let yieldDiv = document.getElementById('yield-div');
    let nowInYieldDiv = yieldDiv.children[0];

    if (event.target.textContent === 'Allocation') {
      let allocationPage = document.createElement("div");
      let h1 = document.createElement("h1");
      let h1Content = document.createTextNode("Allocation");
      h1.appendChild(h1Content);
      let div = document.createElement("div");
      div.setAttribute('id', 'canvas-container');
      let canvas = document.createElement("canvas");
      canvas.setAttribute('id', 'allocation-canvas');
      canvas.setAttribute('width', '300');
      canvas.setAttribute('height', '300');
      div.appendChild(canvas);


      allocationPage.appendChild(h1);
      allocationPage.appendChild(div);

      nowInYieldDiv.replaceWith(allocationPage);
      
      /// Matt's code from allocation.js
        const doughCanvas = document.getElementById("allocation-canvas");
        const ctx = doughCanvas.getContext("2d");

        // let colors = ['#4CAF50', '#00BCD4', '#E91E63', '#FFC107', '#9E9E9E', '#CDDC39'];
        // Different Color Scheme:
        let colors = ['#B2ECD6', '#7077AA', '#B6BED8', '#CDD4E7', '#00D4A3', '#01A881']
        let angles = [Math.PI * 0.3, Math.PI * 0.7, Math.PI * 0.2, Math.PI * 0.4, Math.PI * 0.4];

        let beginAngle = 0;
        let endAngle = 0;

        // Create pie chart pieces
        for(let i = 0; i < angles.length; i = i + 1) {
          beginAngle = endAngle;
          endAngle = endAngle + angles[i];

          ctx.beginPath();
          ctx.fillStyle = colors[i % colors.length];

          ctx.moveTo(150, 150);
          ctx.arc(150, 150, 150, beginAngle, endAngle);
          ctx.lineTo(150, 150);
          ctx.fill();
        }

        // Cover center of pie with a smaller white circle ;)
        ctx.beginPath();
        ctx.fillStyle = '#FFFFFF';
        ctx.moveTo(150, 150);
        ctx.arc(150, 150, 80, 0, 360);
        ctx.lineTo(150, 150);
        ctx.fill();
      } else if (event.target.textContent === 'Balances') {
                 nowInYieldDiv.replaceWith(balancesTable);

      } else if (event.target.textContent === 'Performance') {
        let performancePage = document.createElement("div");
        let h1 = document.createElement("h1");
        let h1Content = document.createTextNode("Performane");
        h1.appendChild(h1Content);
        performancePage.appendChild(h1);
        nowInYieldDiv.replaceWith(performancePage);
      }
  });
})

