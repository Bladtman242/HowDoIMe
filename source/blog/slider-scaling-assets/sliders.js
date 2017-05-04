var sliders = {
    getPoints: function (slider) {
        //placeholders
        points={length:0};
        var view = {
            maxvalue: 0,
            count: 0,
            totaldata: 0,
        };

        if(slider == "slider-linear") {
            var max = document.getElementById(slider).value;
            data.forEach(function(p){
                if (p.focal_length <= max){
                    points.length++;
                }
            });
            view.maxvalue = max;
            view.count = points.length;
            view.totaldata = data.length;
        }

        if(slider == "slider-equalized") {
            var sliderval = document.getElementById(slider).value;
            var max=45;
            var maxI=0;
            //Find the filter value
            for(i=45; i <= sliderval; i++){
                if(i in map){
                    maxI=i;
                    max = map[i];
                }
            }
            //Find the next valid index
            var nextFilter=max;
            var nextFilterI=maxI;
            for(i=maxI+1; i<=8000; i++){
                if(i in map) {
                    nextFilter = map[i];
                    nextFilterI = i;
                    break;
                }
            }
            data.forEach(function(p){
                if (p.focal_length <= max){
                    points.length++;
                }
            });
            if(nextFilterI == maxI) {
                view.maxvalue = max;
            } else {
                view.maxvalue = Math.round(max + (nextFilter - max) * ((sliderval-maxI)/(nextFilterI - maxI)));
            }
            view.count = points.length;
            view.totaldata = data.length;
        }

        return view;
    },
    sliderUpdate:  function sliderUpdate(slider){
        var view = this.getPoints(slider);
        var template = document.getElementById("mustache-templ").innerHTML;
        var target = document.getElementById(slider + "-contentpane");
        var rendered = Mustache.render(template, view);
        target.innerHTML = rendered;
    },

    init: function init() {
        var initSlider = function(slider, min, max) {
            var sliderinput = document.getElementById(slider);
            var mindiv = document.getElementById(slider + "-min");
            var maxdiv = document.getElementById(slider + "-max");

            sliderinput.min = min;
            sliderinput.max = max;
            mindiv.innerHTML = min;
            maxdiv.innerHTML = max;
            sliderinput.value = (min+max)/2
        }

        //linear
        lin_max = data[data.length -1].focal_length;
        lin_min = data[0].focal_length;
        initSlider("slider-linear", lin_min, lin_max);

        //hist equalized
        eq_max = lin_max;
        eq_min = lin_min;
        initSlider("slider-equalized", eq_min, eq_max);

        this.sliderUpdate("slider-linear");
        this.sliderUpdate("slider-equalized");
    }
}
