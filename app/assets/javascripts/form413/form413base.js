// form413
function to_currency(num)
{
    return Math.round(num * 100) / 100;
}

// form413
function num_to_fixed_string(num)
{
    return num.toFixed(2).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
}

// form413
function intVal(i)
{
    if (typeof i === 'string') {
        return i.replace(/[\$,]/g, '') * 1;
    } else if (typeof i === 'number') {
        return i;
    } else {
        return 0;
    }
}

// assets/javascripts/form413/roth_ira_retirement.coffee
// assets/javascripts/form413/assessed_taxes.coffee
// assets/javascripts/form413/stocks_and_bonds.coffee
function getFormattedDate(date) {
    var year = date.getFullYear();
    var month = (1 + date.getMonth()).toString();
    month = month.length > 1 ? month : '0' + month;
    var day = date.getDate().toString();
    day = day.length > 1 ? day : '0' + day;
    return month + '/' + day + '/' + year;
}

// assets/javascripts/form413/assessed_taxes.coffee
// assets/javascripts/form413/roth_ira_retirement.coffee
// app/assets/javascripts/form413/stocks_and_bonds.coffee
function isValidDate(date)
{
    var matches = /^(\d{2})[\/](\d{2})[\/](\d{4})$/.exec(date);
    if (matches == null) return false;
    var d = matches[2];
    var m = matches[1] - 1;
    var y = matches[3];
    var composedDate = new Date(y, m, d);
    return composedDate.getDate() == d &&
        composedDate.getMonth() == m &&
        composedDate.getFullYear() == y;
}
