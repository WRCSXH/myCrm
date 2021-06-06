<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
    /*
        需求：统计交易表中不同阶段的数量，最终形成一个漏斗图（倒三角）

        将数量较多的阶段往上面排列，将数量较少的阶段往下面排列

        例如：
            01资质审查  10条
            02需求分析  85条
            03价值建议  3条
            ......
            07成交    100条
        sql：
            按照阶段进行分组
            resultType="Map"

            select
                count(*),stage
            from
                tbl_tran
            group by
                stage
        npm：
            install jquery
     */
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <!-- 引入 ECharts 文件 -->
    <script type="text/javascript" src="ECharts/echarts.min.js"></script>
    <script type="text/javascript">
        $(function () {
            getCharts();
        })
        function getCharts() {

            $.ajax({
                url:"workbench/transaction/getCharts.do",
                type:"get",
                dataType:"json",
                success:function(result){
                    // result{"total":?,"dataList":[{"value":?,"name":?},{},{}],"nameList":["name1","2","3"]}

                    // 基于准备好的dom，初始化Echarts实例
                    var myChart = echarts.init(document.getElementById('main'));

                    // 指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '交易统计图',
                            subtext: '统计交易阶段数量的漏斗图'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c}%"
                        },
                        toolbox: {
                            feature: {
                                dataView: {readOnly: false},
                                restore: {},
                                saveAsImage: {}
                            }
                        },
                        legend: {
                            data: result.nameList
                            /*[
                                '01资质审查',
                                '02需求分析',
                                '03价值建议',
                                '04确定决策者',
                                '05提案/报价',
                                '06谈判/复审',
                                '07成交',
                                '08丢失的线索',
                                '09因竞争丢失关闭'
                            ]*/
                        },

                        series: [
                            {
                                name:'交易统计图',
                                type:'funnel',
                                left: '10%',
                                top: 60,
                                //x2: 80,
                                bottom: 60,
                                width: '80%',
                                // height: {totalHeight} - y - y2,
                                min: 0,
                                max: result.total,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data: result.dataList
                                /*[
                                    {value: 60, name: '01资质审查'},
                                    {value: 40, name: '02需求分析'},
                                    {value: 20, name: '03价值建议'},
                                    {value: 80, name: '04确定决策者'},
                                    {value: 100, name: '05提案/报价'},
                                    {value: 70, name: '06谈判/复审'},
                                    {value: 90, name: '07成交'},
                                    {value: 30, name: '08丢失的线索'},
                                    {value: 10, name: '09因竞争丢失关闭'}
                                ]*/
                            }
                        ]
                    };

                    // 使用刚指定的配置项和数据显示图表
                    myChart.setOption(option);
                }
            })
        }
    </script>
</head>
<body>
    <!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
    <div id="main" style="width: 600px;height:400px;"></div>
</body>
</html>