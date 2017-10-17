import React from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';

export default class LineGraph extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            graph_width: 200,
        };

    }

    componentDidMount(){
        this.setState({
            graph_width: this.refs.graph.offsetWidth,
        });
    }

    render() {
        return (
            <div ref="graph">
                <LineChart width={this.state.graph_width} height={600} data={this.props.data}>
                    <XAxis dataKey="date"/>
                    <YAxis/>
                    <CartesianGrid strokeDasharray="3 3"/>
                    <Tooltip/>
                    <Line type="monotone" dataKey="value" stroke="#8884d8" activeDot={{r: 8}}/>
                </LineChart>
            </div>
        );
    }
}