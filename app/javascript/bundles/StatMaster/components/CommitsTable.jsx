import React from 'react';
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
            commits: props.commits,
        }
    }

    componentWillReceiveProps(nextProps) {
        if (this.state.commits !== nextProps.commits)
            this.setState({commits: nextProps.commits});
    }

    render() {
        return (
            <div ref="commits_table">
                <Table>
                    <TableHeader>
                        <TableRow>
                            <TableHeaderColumn key={sKey('ct')}>Date</TableHeaderColumn>
                            <TableHeaderColumn key={sKey('ct')}>Commit messages</TableHeaderColumn>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {Object.keys(this.state.commits).map((date, i) =>
                            <TableRow key={sKey('ct')}>
                                <TableRowColumn key={sKey('ct')}>{date}</TableRowColumn>
                                <TableRowColumn key={sKey('ct')}>
                                    {this.state.commits[date].split("\n").map(i => {
                                        return <div key={sKey('ct')}>{i}</div>;
                                    })}
                                </TableRowColumn>
                            </TableRow>
                        )}
                    </TableBody>
                </Table>
            </div>
        )
    }
}