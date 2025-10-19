HTMLWidgets.widget({

  name: 'ratewidget',

  type: 'output',

  factory: function(el, width, height) {

    // Filter obj, returning a new obj containing only
    // values with keys in keys.
    var filterKeys = function(obj, keys) {
      var result = {};
      keys.forEach(function(k) {
        if (obj.hasOwnProperty(k))
          result[k]=obj[k];});
      return result;
    };

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        // Make a data object with keys so we can easily update the selection
        var data_num = {};
        var i;
        if (x.settings.crosstalk_key === null) {
          for (i=0; i<x.data_num.length; i++) {
            data_num[i] = x.data_num[i];
          }
        } else {
          for (i=0; i<x.settings.crosstalk_key.length; i++) {
            data_num[x.settings.crosstalk_key[i]] = x.data_num[i];
          }
        }

        // Make a data object with keys so we can easily update the selection
        var data_den = {};
        var i;
        if (x.settings.crosstalk_key === null) {
          for (i=0; i<x.data_den.length; i++) {
            data_den[i] = x.data_den[i];
          }
        } else {
          for (i=0; i<x.settings.crosstalk_key.length; i++) {
            data_den[x.settings.crosstalk_key[i]] = x.data_den[i];
          }
        }

        // Update the display to show the values in d
        var update = function(d_num, d_den) {
          // Get a simple vector. Don't use Object.values(), RStudio doesn't seem to support it.
          var values_num = [];
          for (var key in d_num) {
            if (d_num.hasOwnProperty(key)) { values_num.push(d_num[key]);}
          }

          var values_den = [];
          for (var key in d_den) {
            if (d_num.hasOwnProperty(key)) { values_den.push(d_den[key]);}
          }

          var value_num = 0;
          // sum up all values in values_num

          value_num = values_num.reduce(function(acc, val) {return acc + val;}, 0);

          var value_den = 0;
          value_den = values_den.reduce(function(acc, val) {return acc + val;}, 0);

          var prop = value_num / value_den * x.settings.multiplier;

          if (x.settings.digits !== null) prop = prop.toFixed(x.settings.digits);
          el.innerText = prop;
        };

       // Set up to receive crosstalk filter and selection events
       var ct_filter = new crosstalk.FilterHandle();
       ct_filter.setGroup(x.settings.crosstalk_group);
       ct_filter.on("change", function(e) {
         if (e.value) {
           update(filterKeys(data_num, e.value), filterKeys(data_den, e.value));
         } else {
           update(data_num, data_den);
         }
       });

       var ct_sel = new crosstalk.SelectionHandle();
       ct_sel.setGroup(x.settings.crosstalk_group);
       ct_sel.on("change", function(e) {
         if (e.value && e.value.length) {
           update(filterKeys(data_num, e.value), filterKeys(data_den, e.value));
         } else {
           update(data_num, data_den);
         }
       });

       update(data_num, data_den);

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
