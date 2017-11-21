import React from 'react';
import {LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ReferenceLine, Text} from 'recharts';
import {
    Table,
    TableBody,
    TableHeader,
    TableHeaderColumn,
    TableRow,
    TableRowColumn,
} from 'material-ui/Table';
import CommitsTable from './CommitsTable';
import sKey from './sKey';
import getColorForGraph from './getColorForGraph';
import * as SUtils from './SUtils';

export default class LineGraph extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            graph_width: 600,
            commits: [],
            graph_data: props.data,
            metric_enabled: props.metric_enabled,
            metric_selected: props.metric_selected,
            services_selected: props.services_selected,
            commits_data_enabled: props.commits_data_enabled,
            commits_data_visibility: props.commits_data_visibility,
            metric_visibility: {display: 'none'},
            services_selected_with_labels: props.services_selected_with_labels,
            source_graph_data: props.data,
            waiter_handler: props.waiter_handler
        };
    }

    sortObjectDataByDate(data) {
        let prop_array = [];
        for (let prop in data)
            if (data.hasOwnProperty(prop))
                prop_array.push(data[prop].date);
        //sorted by asc
        prop_array.sort((a, b) => Date.parse(a) - Date.parse(b));

        let new_data = [];
        prop_array.map((element, i) => {
            for (let prop in data)
                if (data.hasOwnProperty(prop))
                    if (data[prop].date === element)
                        new_data[i] = data[prop]
        });

        return new_data;
    }

    getCommitsData = () => {
        this.props.waiter_handler(true);
        const query = '/commits_data';

        fetch(query)
            .then((response) => response.json())
            .then((payload) => {
                const commits = payload.data;
                this.setState({commits: commits}, () => {
                    this.realign();
                    this.props.waiter_handler(false);
                });
            });
    };

    componentWillReceiveProps(nextProps) {
        console.log('receiving props');

        //todo rewrite this /////////////////////
        //commits
        if (nextProps.commits_data_enabled && !this.state.commits_data_enabled) {
            this.getCommitsData();
            this.setState({
                commits_data_visibility: nextProps.commits_data_visibility,
                commits_data_enabled: nextProps.commits_data_enabled
            });
        }

        if (nextProps.commits_data_enabled === false && this.state.commits_data_enabled) {
            this.setState({
                commits_data_visibility: nextProps.commits_data_visibility,
                commits_data_enabled: nextProps.commits_data_enabled
            });
        }

        //metrika
        if (nextProps.metric_enabled)
            this.setState({metric_visibility: {display: 'inline-block'}});
        else
            this.setState({metric_visibility: {display: 'none'}});

        //todo //////////////////////////////////

        if (nextProps.data !== this.state.source_graph_data
            || nextProps.metric_enabled !== this.state.metric_enabled
            || nextProps.metric_selected !== this.state.metric_selected) {

            if (nextProps.metric_enabled && nextProps.metric_selected !== null)
                this.getMetricsData(nextProps.data, nextProps.metric_selected);

            this.setState({
                source_graph_data: nextProps.data,
                graph_width: 600,
                commits: this.state.commits,
                graph_data: nextProps.data,
                metric_enabled: nextProps.metric_enabled,
                metric_selected: nextProps.metric_selected,
                services_selected: nextProps.services_selected,
                services_selected_with_labels: nextProps.services_selected_with_labels
            }, () => this.realign());
        } else
            console.log('nothing to update');
    }

    getMetricsData(rows, metric) {
        this.props.waiter_handler(true);
        let dates = [];
        Object.keys(rows).map((prop, i) => dates.push(rows[prop]['date']));

        if (dates.length === 0)
            return;

        const datesJson = JSON.stringify(dates);

        //todo rework it!
        ///metrics_data?metrics=ym:s:pageviews&dates=' + datesJson + '&service_ids=' + this.state.services_selected.join(',')
        fetch('/metrics_data?metrics=' + metric + '&dates=' + datesJson + '&service_ids=' + this.state.services_selected.join(','))
            .then((response) => response.json())
            .then((payload) => {
                const metric_data = payload.data;
                const merged_data = SUtils.merge_data(metric_data, this.state.graph_data);

                this.setState({graph_data: merged_data}, () => this.props.waiter_handler(false));
            });
    }

    componentDidMount() {
        this.realign();
        // this.getCommitsData()
    }

    realign = () => this.setState({graph_width: this.refs.graph.offsetWidth});

    render() {
        return (
            <div ref="graph">
                <LineChart width={this.state.graph_width} height={600}
                           data={this.sortObjectDataByDate(this.state.graph_data)}>
                    <XAxis dataKey="date"/>
                    <YAxis yAxisId="left"/>
                    <YAxis yAxisId="right" orientation="right"/>

                    <CartesianGrid strokeDasharray="3 3"/>
                    <Tooltip/>
                    {this.state.commits_data_visibility ? Object.keys(this.state.commits).map((date, i) =>
                        <ReferenceLine
                            style={this.state.commits_data_visibility}
                            key={sKey('ln')}
                            x={date}
                            stroke="red"
                            label={this.state.commits[date].split("\n").map(i => {
                                return <div>{i}</div>;
                            })}/>
                    ) : null}
                    {this.state.services_selected.map((service, i) => {
                        return ([
                            <Line name={this.state.services_selected_with_labels[service]} key={sKey('ln')}
                                  yAxisId="left" type="monotone" dataKey={'value_' + service}
                                  stroke={getColorForGraph()} activeDot={{r: 8}}/>,
                            <Line name={'Metric ' + this.state.services_selected_with_labels[service]}
                                  style={this.state.metric_visibility} yAxisId="right" key={sKey('ln')} type="monotone"
                                  dataKey={'metric_value_' + service} stroke={getColorForGraph()} activeDot={{r: 8}}/>
                        ]);
                    })}
                </LineChart>
                {this.state.commits_data_enabled ? <CommitsTable commits={this.state.commits}/> : null}
            </div>
        );
    }
}