var jdo1 = Module.cwrap('em_jdo','string',['string'])
var jsetstr = Module.cwrap('em_jsetstr','void',['string','string'])
var jsetstrPtr = Module.cwrap('em_jsetstr','void',['string','int'])
var jgetstr = Module.cwrap('em_jgetstr','string',['string'])


function SimpleController($scope, $http, $routeParams,$filter) {
    $scope.SideCollapsed = true;
    $scope.DeveloperMode = false;
    console.log($routeParams);

    $scope.Dashboard = $routeParams.dashboard||'dashboard';
    //document.title = $scope.Dashboard;

    $scope.Script = ''
    $scope.WidgetTypes = ['Chart','Tile', 'Table', 'Spacer', 'Html']
    $scope.gridsterOpts = {
        minRows: 2, // the minimum height of the grid, in rows
        minColumns: 10,
      maxRows: 1000,
      columns: 10, // the width of the grid, in columns
      colWidth: 'auto', // can be an integer or 'auto'.  'auto' uses the pixel width of the element divided by 'columns'
      rowHeight: '100', // can be an integer or 'match'.  Match uses the colWidth, giving you square widgets.
      margins: [5, 5], // the pixel distance between each widget
      defaultSizeX: 1, // the default width of a gridster item, if not specifed
      defaultSizeY: 1, // the default height of a gridster item, if not specified
      mobileBreakPoint: 600, // if the screen is not wider that this, remove the grid layout and stack the items
      resizable: {
         enabled: true,
         start: function(event, uiWidget, $element) {}, // optional callback fired when resize is started,
         resize: function(event, uiWidget, $element) {}, // optional callback fired when item is resized,
          stop: function(event, uiWidget, $element) {
              //console.log([uiWidget, $element]);
              $scope.DrawCharts($element.index);
          } // optional callback fired when item is finished resizing
      },
      draggable: {
         enabled: true, // whether dragging items is supported
      }
    };
    
    window.scope = $scope;
    window.$http = $http;



    Module['postRun'] = function() {
        jsetstr('CODE_z_', document.getElementById('embedded_j_code').innerText);
        jdo1('(0!:100) CODE_z_')
        $.get('dashboard.json?rnd=' + Math.random()).then(function(json) { 
            loadDashboard(json);
            $scope.$digest();
            $scope.Refresh();
         })
        
    }

    $scope.$watch('DeveloperMode', function(nv, ov) {
        //$scope.gridsterOpts.draggable =  $scope.DeveloperMode;
    }, true);
    
    $scope.IsLoaded = false;

    var loadDashboard = function(json) {
        $scope.Script = decodeURIComponent(json.Script||'');
        $scope.Javascript = decodeURIComponent(json.Javascript||'');


        if (json.Charts) {
            json.Charts.forEach(function(x) {
		        delete x.Active;
	        });
            $scope.Charts = json.Charts;
        }
        $scope.Charts.forEach(function(chart) {
            Object.keys(chart).forEach(function(x) {
                if (x == "Query" || x == "Javascript" || x =="Html") {
                    chart[x] = decodeURIComponent(chart[x]);
                }
            });
        });

        if ($scope.Javascript) {
            eval($scope.Javascript);
        }

    }

    $scope.Refresh = function() {
        /*
        $http.post('/Eval', { script: $scope.Script, cmd: '(0!:0) script'}).success(
            function(json) {
                $scope.DrawCharts();
            })
        */
       jsetstr('CODE_z_', $scope.Script);
       jdo1('(0!:100) CODE_z_');
       
       $scope.DrawCharts();
       $scope.$digest();
    }
    $scope.Save = function() {
        //$scope.Script = window.aceEditors["Script"].getValue();
        var dto = {
            Script: encodeURIComponent(($scope.Script||'')),
            Javascript: encodeURIComponent(($scope.Javascript||'')),
            Charts: []
        }
        $scope.Charts.forEach(function(chart) {
            if (chart.NoSave) { return; }
            var dtoChart = {}
            Object.keys(chart).forEach(function(x) {
                if (x != 'Data') {
                    dtoChart[x] = chart[x];
                }
                if (x == "Query" || x == "Javascript" || x == "Html") {
                    dtoChart[x] = encodeURIComponent(chart[x]);
                }
            });
            dto.Charts.push(dtoChart);
        });
        //$http.post('Eval', { cmd: "saveJson 'dashboards/" +  $scope.Dashboard + ".json'", json: angular.toJson(dto) }).success(
        //    function(json) { console.log("saved") })
        var json = angular.toJson(dto);
        console.log(json);
        navigator.clipboard.writeText(json);
    }


    
    $scope.Charts = [];

    $scope.OnBlur = function(idx, col) {
        console.log(idx);
    }

    $scope.Share = function() {
        scope.Charts.forEach(function(chart) {
            delete chart.SearchVal
        });
        var param1 = btoa(JSON.stringify(scope.Charts));
        window.location.hash = param1;
    }

    var merge = window.merge =  function(o, more) {
        var dto = Object.keys(o).filter(function(x) { return x!='$$hashKey' }).reduce(function(obj, key) { obj[key] = o[key]; return obj; }, {});
        if (more) {
            dto = Object.keys(more).reduce(function(obj, key) { obj[key] = more[key]; return obj; }, dto);
        }
        return dto;
    }

    $scope.AddChart = function() {
        var lastRow = 2;
        $scope.Charts.forEach(function(x) {
            if (x.row > lastRow) { lastRow = x.row; }
        });
        var chart = { WidgetType: 'Chart', sizeX: 25, sizeY: 10, row: lastRow+1, col: 0, index: $scope.Charts.length }
        $scope.Charts.push(chart);
        //$scope.DrawCharts(chart.index);
    }

    function toDate(str) {
        str = str.toString();
        return str.substring(0,4) + '-' + str.substring(4,6);
    }

    function uniq(arr) {
        return Object.keys(arr.reduce(function(dict, val) { dict[val] = 1; return dict}, {}))
    }

    $scope.ClickTile = function(tile) {
        $scope.Charts.forEach(function(x) {
            x.Active = false;
        });
        tile.Active = true;
        $scope.ActiveTile = tile;
        $scope.CurrentMetric = tile.Formula;
        $scope.DrawCharts();
    }


    $scope.ChangeSorting = function (item, column) {
        if (!item.sort) { item.sort = {} };
        var sort = item.sort;

        
        if (sort.column == column) {
            sort.descending = !sort.descending;
        } else {
            sort.column = column;
            sort.descending = false;
        }

        var orderFunc = function (row) {
            return row[item.sort.column];
        }

        item.Rows = $filter('orderBy')(item.Rows, orderFunc, sort.descending);
    };

    $scope.DrawCharts = function(index, runAll) {
        var chart;

        if (index != undefined && index >= $scope.Charts.length) {
            return;
        }
        
        if (index != undefined)
            chart = $scope.Charts.filter(function(x) { return x.index == index})[0];
        else {
            $scope.DrawCharts(0, true);
        }
        if (chart == undefined) { return; }
        
        var i = chart.index;

        //skip chart if drawing a specific chart

        var dto =  { GroupBy: ($scope.GroupBy||''), CurrentMetric: ($scope.CurrentMetric||''),  script: chart.Query, cmd: 'tojson 0 [ (0!:0) script' };
        if ($scope.OnBeforeDraw) {
            $scope.OnBeforeDraw(dto);
        }

        if (($scope.CurrentMetric||'')=='') {
            $scope.CurrentMetric = 'cases';
        }
        jsetstr("CurrentMetric", $scope.CurrentMetric);
        jsetstr('CODE_z_', chart.Query);
        var cmd = jdo1('(0!:100) CODE_z_');
        var ret = jdo1('enc JSON');
        //if (ret.startsWith("|")) return;
        var json = angular.fromJson(ret);
        //console.log(json);
        var layout = {}
        var $item = $('#Chart' + i);
        layout.height = $item.parents('li:first').height() * 0.95;
        layout.width =  $item.width();
        layout.margin = {l: 40, t: 60, r: 20};
        var traces = [];
        [1,2,3,4].forEach(function(x) {
            if (json['Series' + x + '_x']) {
                var trace = { }
                var key = "Series" + x + "_";
                trace.x = json[key+"x"];
                trace.y = json[key+"y"];
                trace.name = json[key+"name"][0];
                trace.type = "bar";
                traces.push(trace);
            }
            if (json['Tile' + x]) {
                chart['Tile' + x] = json['Tile'+x][0]
            }
        });
        chart.Data = json;
        if (json.Rows) {
            chart['Rows'] = json.Rows;
        }
        if (chart.Title||'') {
            layout.title = chart.Title;
        }

        if (chart.Javascript) {
            eval(chart.Javascript);
        }


        if (document.getElementById('Chart' + i) == undefined) return;

        if (!chart.WidgetType || chart.WidgetType == 'Chart') {
            Plotly.newPlot('Chart' + i, traces, layout, {showLink: false, displaylogo: false});
        }
        if (chart.WidgetType == "Tile") {
            //$('#Tile' + i).height(layout.height);
        }
        if (runAll) {
            $scope.DrawCharts((i+1), true);
        }
        
    }

    $scope.GetMargin = function(chart) {
        return { "height" : chart.MarginTop + "px"}
    }
    $scope.ConfigureChart = function(chart) {
        $scope.LastChart = chart;
        $('#ConfigDialog').dialog({
            width: 900,
            height: 500,
            buttons: {
                'Add Spacer' : function() {
                    var newChart = $scope.CloneChart(chart);
                    newChart.WidgetType = 'Spacer';
                    delete newChart.Query;
                    delete newChart.Html;
                    delete newChart.Javascript;
                    $scope.$apply();
                    $(this).dialog('close')
                },
                'Clone' : function() {
                    $scope.CloneChart(chart);
                    $scope.$apply();
                    $(this).dialog('close')
                },
                'Close' : function() {
                    $scope.DrawCharts($scope.LastChart.index);
                    $(this).dialog('close');
                }
            }
        });
    }

    $scope.OpenSettings = function(chart) {
        $('#SettingsDialog').dialog({
            width: 850,
            height: 500,
            buttons: {
                'Close' : function() {
                    $scope.Save();
                    $(this).dialog('close');
                }
            }
        });
    }
    
    $scope.RemoveChart = function(chart) {
        if (!confirm('Are you sure you wish to remove this chart?')) { return; }
        $scope.Charts = $scope.Charts.filter(function(x) { return x != chart; });
        scope.Charts.map(function(x,i) { x.index = i; })
        event.preventDefault();
    }

    $scope.CloneChart = function(chart) {
        var newChart = JSON.parse(angular.toJson(merge(angular.copy(chart))));
        newChart.index = $scope.Charts.length;
        $scope.Charts.push(newChart);
        $scope.DrawCharts(newChart);
        return newChart;
    }
    $scope.Reset = function() {
        window.location.hash = '';
        $scope.Charts = [];
        $scope.AddChart();
    }

    setTimeout(function() {
        $('#Sidebar').height($(document).height());
        $('#Sidebar').width(25);
    });

    $scope.ToggleSidebar = function() {
        $scope.SideCollapsed = !$scope.SideCollapsed;
        if ($scope.SideCollapsed) {
            $('#Sidebar').width(25);
            $('#SidebarContent').hide();
        } else {
            $('#Sidebar').width(300);
            $('#SidebarContent').show();
        }
    }

}

window.aceEditors = {}
angular.module('ace', []).directive('ace', function($timeout) {
    var ACE_EDITOR_CLASS = 'ace-editor';

    function loadAceEditor(element, mode) {
        var editor = ace.edit(element);
        window.editor = editor;
        editor.getSession().setUseWorker(false);
        //editor.setTheme("ace/theme/chrome");
        //editor.getSession().setMode("ace/mode/" + mode);
        editor.renderer.setShowPrintMargin(false);

        return editor;
    }

    function valid(editor) {
        return (Object.keys(editor.getSession().getAnnotations()).length == 0);
    }

    return {
        restrict: 'EA',
        require: '?ngModel',
        //transclude: true,
        //template: '<div class="transcluded" ng-transclude></div><div class="' + ACE_EDITOR_CLASS + '"></div>',
        link: function(scope, element, attrs, ngModel) {
            var textarea = $(element);

            var height = attrs.height || 200;
            var editDiv = $('<div style="width:800px;height:' + height + 'px"><div class="' + ACE_EDITOR_CLASS + '" style="width:800px;height:' + height + 'px"></div></div>');




            //textarea.attr('data-Model', attrs.ngModel);
            editDiv.insertBefore(element);
            editDiv.find('.ace_editor').height(height);
            textarea.hide();

            var mode = attrs.ace;

            window.element = element;
            var editor = loadAceEditor(editDiv.children('div')[0], mode);

            window.aceEditors[attrs.ngModel] = editor;

            editDiv.data('editor', editor);

            scope.$watch('Advanced', function() {
                $timeout(function() { editor.resize(); }, 200);
            });

            if (!ngModel) return; // do nothing if no ngModel

            ngModel.$render = function() {
                var value = ngModel.$viewValue || '';
                editor.getSession().setValue(value);
                textarea.val(value);
            };

            editor.getSession().on('change', function() {
                read();
            });

            editor.commands.addCommand({
                name: "save",
                bindKey: { win: "Ctrl-S", mac: "Command-Option-S" },
                exec: function(editor) {
                    $('#QuickSave').click();
                }
            });

            editor.commands.addCommand({
                name: "replace",
                bindKey: { win: "Ctrl-B", mac: "Command-Option-B" },
                exec: function(editor) {
                    $('#RunTests').click();
                }
            });

            editor.commands.addCommand({
                name: "unfullscreen",
                bindKey: { win: "Ctrl-F11" },
                exec: function(editor) {
                    editDiv.parent('div').height(210).width(800);
                    editDiv.find('.ace_editor').height(200).width(800);
                    editor.resize();
                }
            });

            editor.commands.addCommand({
                name: "fullscreen",
                bindKey: { win: "Alt-F11" },
                exec: function(editor) {
                    var h = $(window).height() * 0.9;
                    var w = $(window).width() * 0.9;
                    editDiv.parent('div').height(h).width(w);
                    editDiv.find('.ace_editor').height(h).width(w);
                    editor.resize();
                }
            });
            editor.getSession().setValue(textarea.val());

            var langTools = ace.require("ace/ext/language_tools");
            editor.setOptions({enableBasicAutocompletion: true});

            var completer = {
                getCompletions: function(editor, session, pos, prefix, callback) {
                    if (prefix.length === 0 || scope.Definition == undefined) { callback(null, []); return }
                    callback(null, scope.Definition.Columns.map(function(ea) {
                        return {name: ea.Column, value: ea.Column, score: 100, meta: "Table"}
                    }));

                }
            }
            //langTools.addCompleter(completer);

            editor.resize();

            function read() {
                ngModel.$setViewValue(editor.getValue());
                textarea.val(editor.getValue());
            }

        }

    }
}).filter('split', function() {
        return function(input, splitChar, index) {
            if (!input) return null;
            // do some bounds checking here to ensure it has that index
            if (index !== undefined)
                return input.split(splitChar)[index];
            return input.split(splitChar);
        }
});

var app = angular.module('demo', ['gridster', 'ace', 'ngRoute']).config(['$routeProvider', function($routeProvider) {
    $routeProvider.
        when('/', {templateUrl: '/partials/index.html',   controller: SimpleController}).
        when('/dashboard/:dashboard', {templateUrl: '/partials/index.html',   controller: SimpleController}).
        otherwise({redirectTo: '/'});
}]).config(['$httpProvider', function ($httpProvider) {
        $httpProvider.defaults.cache = false;
        if (!$httpProvider.defaults.headers.get) {
            $httpProvider.defaults.headers.get = {};
        }
        $httpProvider.defaults.headers.get['If-Modified-Since'] = '0';
    }]);

app.filter('numeric', ['$filter', function ($filter) {
    return function (val, fmt) {
        if (val == undefined) { return ''; }
        return numeral(numeral().unformat(val.toString())).format(fmt);
    };
}]);

app.directive('eatClick', function () {
    return function (scope, element, attrs) {
        $(element).click(function (event) {
            event.preventDefault();
            return false;
        });
    };
});

app.directive('dynamic', function ($compile) {
    return {
        restrict: 'A',
        replace: true,
        link: function (scope, ele, attrs) {
            scope.$watch(attrs.dynamic, function (html) {
                ele.html(html);
                $compile(ele.contents())(scope);
            });
        }
    };
});

