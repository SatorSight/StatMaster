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

    getCommitsData = () => {
        const query = '/commits_data';

        fetch(query)
            .then((response) => response.json())
            .then((payload) => {
                const commits = payload.data;
                this.setState({commits: commits});
            });
    };

    constructor(props) {
        super(props);

        this.state = {
            graph_width: 600,
            commits: [],
            data: props.data
        };
    }

    componentWillReceiveProps(props) {
        this.setState({
            graph_width: 600,
            commits: [],
            data: props.data
        }, () => this.realign());
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
                <LineChart width={this.state.graph_width} height={600} data={this.state.data}>
                    <XAxis dataKey="date"/>
                    <YAxis/>
                    <CartesianGrid strokeDasharray="3 3"/>
                    <Tooltip/>
                    {Object.keys(this.state.commits).map((date, i) =>
                        <ReferenceLine key={sKey('ln')} x={date} stroke="red" label={this.state.commits[date].split("\n").map(i => {
                            return <div>{i}</div>;
                        })}/>
                    )}
                    <Line type="monotone" dataKey="value" stroke="#8884d8" activeDot={{r: 8}}/>
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