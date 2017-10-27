import React from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ReferenceLine, Text } from 'recharts';
import {
    Table,
    TableBody,
    TableHeader,
    TableHeaderColumn,
    TableRow,
    TableRowColumn,
} from 'material-ui/Table';
import sKey from './sKey';

export default class LineGraph extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            graph_width: 600,
            commits: [],
            graph_data: props.data,
            metrics_enabled: props.metrics_enabled,
            metric_selected: props.metric_selected,
            service_id: props.service_id,
            metric_data: []
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
        const query = '/commits_data';

        fetch(query)
            .then((response) => response.json())
            .then((payload) => {
                const commits = payload.data;
                this.setState({commits: commits});
            });
    };

    componentWillReceiveProps(nextProps) {
        console.log('receiving props');
        if (nextProps.data !== this.state.graph_data
            || nextProps.metrics_enabled !== this.state.metrics_enabled
            || nextProps.metric_selected !== this.state.metric_selected) {

            if (nextProps.metrics_enabled && nextProps.metric_selected !== null)
                this.getMetricsData(nextProps.data, nextProps.metric_selected);

            this.setState({
                graph_width: 600,
                commits: this.state.commits,
                graph_data: nextProps.data,
                metrics_enabled: nextProps.metrics_enabled,
                metric_selected: nextProps.metric_selected,
                service_id: nextProps.service_id,
            }, () => this.realign());
        } else
            console.log('nothing to update');
    }

    getMetricsData(rows, metric) {
        let dates = [];
        Object.keys(rows).map((prop, i) => {
            const date = rows[prop]['date'];
            dates.push(date);
        });

        const datesJson = JSON.stringify(dates);

        fetch('/metrics_data?metrics=' + metric + '&dates=' + datesJson + '&service_id=' + this.state.service_id)
            .then((response) => response.json())
            .then((payload) => {
                const metric_data = payload.data;

                Object.keys(rows).map((key, i) => {
                    Object.keys(metric_data).map((key2, i) => {
                        if (metric_data[key2].date === rows[key].date)
                            rows[key].metric = metric_data[key2].value;
                    });
                });

                this.setState({
                    metric_data: {metric: this.state.metric_selected, data: metric_data},
                    graph_data: rows
                });
            });
    }

    componentDidMount(){
        this.realign();
        this.getCommitsData()
    }

    realign = () => {
        this.setState({
            graph_width: this.refs.graph.offsetWidth,
        });
    };

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
                    {Object.keys(this.state.commits).map((date, i) =>
                        <ReferenceLine key={sKey('ln')} x={date} stroke="red" label={this.state.commits[date].split("\n").map(i => {
                            return <div>{i}</div>;
                        })}/>
                    )}
                    <Line yAxisId="left" type="monotone" dataKey="value" stroke="#8884d8" activeDot={{r: 8}}/>
                    <Line yAxisId="right" type="monotone" dataKey="metric" stroke="#ff0000" activeDot={{r: 8}}/>
                </LineChart>
                <Table>
                    <TableHeader>
                        <TableRow>
                            <TableHeaderColumn key={sKey('ln')}>Date</TableHeaderColumn>
                            <TableHeaderColumn key={sKey('ln')}>Commit messages</TableHeaderColumn>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {Object.keys(this.state.commits).map((date, i) =>
                            <TableRow key={sKey('ln')}>
                                <TableRowColumn key={sKey('ln')}>{date}</TableRowColumn>
                                <TableRowColumn key={sKey('ln')}>
                                    {this.state.commits[date].split("\n").map(i => {
                                        return <div key={sKey('ln')}>{i}</div>;
                                    })}
                                </TableRowColumn>
                            </TableRow>
                        )}
                    </TableBody>
                </Table>
            </div>
        );
    }
}