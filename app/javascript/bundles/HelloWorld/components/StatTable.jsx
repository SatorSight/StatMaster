import React from 'react';
import ReactOnRails from 'react-on-rails';
ReactOnRails.register({ LineGraph });

import DatePicker from 'material-ui/DatePicker';
import SelectField from 'material-ui/SelectField';
import MenuItem from 'material-ui/MenuItem';
import Menu from 'material-ui/Menu';
import AppBar from 'material-ui/AppBar';
import Drawer from 'material-ui/Drawer';
import Paper from 'material-ui/Paper';
import {Toolbar, ToolbarGroup, ToolbarTitle} from 'material-ui/Toolbar';
import {Tabs, Tab} from 'material-ui/Tabs';
import CircularProgress from 'material-ui/CircularProgress';
import {Card, CardTitle, CardText} from 'material-ui/Card';
import RaisedButton from 'material-ui/RaisedButton';
import FileDownload from 'material-ui/svg-icons/file/file-download';
import Toggle from 'material-ui/Toggle';

import {
    Table,
    TableBody,
    TableHeader,
    TableHeaderColumn,
    TableRow,
    TableRowColumn,
} from 'material-ui/Table';
import {withStyles, MuiThemeProvider} from 'material-ui/styles';
import LineGraph from './LineGraph'
import sKey from './sKey';

export default class StatTable extends React.Component {

    constructor(props) {
        super(props);

        const selected_stat_id = props.stat_types[0].id;
        const selected_service_id = props.all_services[0].id;

        this.state = {
            stat_selected: selected_stat_id,
            service_selected: selected_service_id,
            stat_types: props.stat_types,
            drawer_open: false,
            rows: props.table.rows,
            date_from: false,
            date_to: false,
            progress_style: {display: 'none'},
            metrics: props.metrics,
            metric_selected: null,
            metrics_visibility: {display: 'none'},
            metrics_active: false,
        };
    }

    toggleDrawer = () => this.setState({ drawer_open: !this.state.drawer_open });
    closeDrawer = () => this.setState({ drawer_open: false });
    metricToggleChanged = (event, isInputChecked) => {
        const display = isInputChecked ? {display: 'inline-block'} : {display: 'none'};
        this.setState({metrics_visibility: display});
        this.setState({metrics_active: isInputChecked})
    };

    menuChanged = (event, value) => this.setState({ service_selected: value }, () => {
        this.toggleDrawer();
        this.renewTable();
    });

    handleMetricSelectChange = (event, index, value) => this.setState({metric_selected: value});
    dateFromChanged = (nothing, date) => this.setState({ date_from: date }, () => this.renewTable());
    dateToChanged = (nothing, date) => this.setState({ date_to: date }, () => this.renewTable());
    statTypeSelectChanged = (event, index, value) => this.setState({ stat_selected: value }, () => this.renewTable());

    renewTable = () => {
        this.setState({ rows: [], progress_style: { display: 'inline-block' } }, () => {
            const query = this.makeQuery('renew_data');
            fetch(query)
                .then((response) => response.json())
                .then((payload) => {
                    const table_rows = payload.data.table_rows;
                    this.setState({rows: table_rows, progress_style: { display: 'none' }});
                });
        });
    };

    makeQuery = (type) => {
        //todo make some query builder
        let query = '/'+type+'?service_id='+this.state.service_selected+'&stat_type_id='+this.state.stat_selected;
        if(this.state.date_from)
            query += '&date_from='+this.state.date_from;
        if(this.state.date_to)
            query += '&date_to='+this.state.date_to;
        return query;
    };

    exportCSV = () => {
        const query = this.makeQuery('csv_data.csv');
        const response = {
            file: query,
        };
        window.location.href = response.file;
    };

    render() {
        return (
            <MuiThemeProvider>
                <div>
                    <AppBar
                        onLeftIconButtonTouchTap={this.toggleDrawer}
                        title="StatMaster"
                    />
                    <Drawer
                        docked={false}
                        open={this.state.drawer_open}
                        onRequestChange={(drawer_open) => this.setState({drawer_open})}>
                        <Paper>
                            <Menu value={this.state.service_selected} onChange={this.menuChanged}>
                                {this.props.all_services.map((service, i) =>
                                    <MenuItem value={service.id}
                                              checked={service.id === this.state.service_selected}
                                              key={sKey('st')}>{service.label}
                                    </MenuItem>
                                )}
                            </Menu>
                        </Paper>
                    </Drawer>
                    <Card>
                        <CardTitle title="Services inner data"/>
                        <CardText>
                            Select service from main menu, stat type and date interval below if needed.
                        </CardText>
                        <Toolbar>
                            <ToolbarGroup>
                                <ToolbarTitle text="Parameters" />
                            </ToolbarGroup>
                            <ToolbarGroup>
                                <SelectField
                                    value={this.state.stat_selected}
                                    autoWidth={true}
                                    onChange={this.statTypeSelectChanged}>
                                    {this.props.stat_types.map((type, i) =>
                                        <MenuItem key={sKey('st')} value={type.id} primaryText={type.title}/>
                                    )}
                                </SelectField>
                            </ToolbarGroup>
                            <ToolbarGroup>
                                <DatePicker key={sKey('st')} value={this.state.date_from}
                                            onChange={this.dateFromChanged} hintText="From" mode="landscape"/>
                            </ToolbarGroup>

                            <ToolbarGroup>
                                <DatePicker key={sKey('st')} value={this.state.date_to} onChange={this.dateToChanged}
                                            hintText="To" mode="landscape"/>
                            </ToolbarGroup>

                            <ToolbarGroup>
                                <RaisedButton
                                    label="Download csv"
                                    labelPosition="before"
                                    primary={true}
                                    onClick={this.exportCSV}
                                    icon={<FileDownload />}
                                />
                            </ToolbarGroup>
                        </Toolbar>
                        <Toolbar>
                            <ToolbarGroup>
                                <Toggle onToggle={this.metricToggleChanged} label="Yandex Metrika"/>
                            </ToolbarGroup>
                            <ToolbarGroup style={this.state.metrics_visibility}>
                                <SelectField
                                    hintText="Type"
                                    value={this.state.metric_selected}
                                    onChange={this.handleMetricSelectChange}
                                    // multiple={true}
                                >
                                    <MenuItem key={sKey('st')} value={null} primaryText=""/>
                                    {Object.keys(this.state.metrics).map((metric, i) =>
                                        <MenuItem key={sKey('st')} value={metric} primaryText={metric}/>
                                    )}
                                </SelectField>
                            </ToolbarGroup>
                        </Toolbar>
                        <Tabs>
                            <Tab label="Table">
                                <Table>
                                    <TableHeader>
                                        <TableRow key={sKey('st')}>
                                            {this.props.table.header_row.map((type, i) =>
                                                <TableHeaderColumn key={sKey('st')}>{type}</TableHeaderColumn>
                                            )}
                                        </TableRow>
                                    </TableHeader>
                                    <TableBody>
                                        {this.state.rows.map((type, i) =>
                                            <TableRow key={sKey('st')}>
                                                <TableRowColumn key={sKey('st')}>{type.id}</TableRowColumn>
                                                <TableRowColumn key={sKey('st')}>{type.service}</TableRowColumn>
                                                <TableRowColumn key={sKey('st')}>{type.date}</TableRowColumn>
                                                <TableRowColumn key={sKey('st')}>{type.value}</TableRowColumn>
                                            </TableRow>
                                        )}
                                    </TableBody>
                                </Table>
                                <div className="row center-xs">
                                    <CircularProgress style={this.state.progress_style} size={100} />
                                </div>
                            </Tab>
                            <Tab label="Graph">
                                <LineGraph data={this.state.rows}
                                           metrics_enabled={this.state.metrics_active}
                                           metric_selected={this.state.metric_selected}
                                           service_id={this.state.service_selected}
                                />
                            </Tab>
                        </Tabs>
                    </Card>
                </div>
            </MuiThemeProvider>
        );
    }
}