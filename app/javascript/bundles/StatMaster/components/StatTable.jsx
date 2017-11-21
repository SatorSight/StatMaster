import React from 'react';
import ReactOnRails from 'react-on-rails';

ReactOnRails.register({LineGraph});

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
import ExpandMore from 'material-ui/svg-icons/navigation/expand-more';
import ExpandLess from 'material-ui/svg-icons/navigation/expand-less';
import Toggle from 'material-ui/Toggle';
import Waiter from './Waiter'

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
import * as SUtils from './SUtils';

const EXPAND_STYLE = {color: 'white', margin: '10px', cursor: 'pointer'};
const SHOW = {display: 'block'};
const HIDE = {display: 'none'};
const METRIC_STYLES = {margin: '-10px 0px 0px 40px'};

export default class StatTable extends React.Component {

    constructor(props) {
        super(props);

        const selected_stat_id = props.stat_types[0].id;
        const selected_service_id = props.all_services[0].id;
        const services_selected = [selected_service_id];

        this.state = {
            stat_selected: selected_stat_id,
            services_selected: services_selected,
            stat_types: props.stat_types,
            drawer_open: false,
            rows: props.table.rows,
            date_from: false,
            date_to: false,
            progress_style: HIDE,
            metrics: props.metrics,
            metric_selected: null,
            metric_visibility: HIDE,
            metric_active: false,
            toolbars_visible: true,
            commits_data_enabled: false,
            commits_data_visibility: HIDE,
            app_bar_expanded: false,
            app_bar_visibility: SHOW,
            table_header: props.table.header_row,
            waiter_enabled: false
        };
    }

    getServiceLabelByID = (id) => {
        let result = null;
        this.props.all_services.map((service, i) => {
            if (service.id === id)
                result = service.label;
        });
        return result;
    };

    getSelectedServicesWithLabels = () => {
        let result = [];
        this.state.services_selected.map((service, i) => {
            result[service] = this.getServiceLabelByID(service);
        });
        return result;
    };

    toggleDrawer = () => this.setState({drawer_open: !this.state.drawer_open});
    closeDrawer = () => this.setState({drawer_open: false});

    metricToggleChanged = (event, isInputChecked) => {
        const display = isInputChecked ? SHOW : HIDE;
        this.setState({metric_visibility: display});
        this.setState({metric_active: isInputChecked})
    };
    commitsDataToggle = (event, isInputChecked) => {
        const display = isInputChecked ? SHOW : HIDE;
        this.setState({commits_data_visibility: display});
        this.setState({commits_data_enabled: isInputChecked})
    };

    menuChanged = (event, value) => this.setState({service_selected: value}, () => {
        this.toggleDrawer();
        this.renewTable();
    });

    handleMetricSelectChange = (event, index, value) => this.setState({metric_selected: value});
    dateFromChanged = (nothing, date) => this.setState({date_from: date}, () => this.renewTable());
    dateToChanged = (nothing, date) => this.setState({date_to: date}, () => this.renewTable());
    statTypeSelectChanged = (event, index, value) => this.setState({stat_selected: value}, () => this.renewTable());

    renewTable = () => {
        this.setState({rows: [], progress_style: SHOW, waiter_enabled: true}, () => {
            const query = this.buildQuery('renew_data');
            fetch(query)
                .then((response) => response.json())
                .then((payload) => {
                    const table_rows = payload.data.table_rows;
                    this.setState({rows: table_rows, progress_style: HIDE}, () =>
                        this.setState({
                            table_header: this.getTableHeaderForRows(),
                            waiter_enabled: false
                        }));
                });
        });
    };

    getTableHeaderForRows = () => {
        const rows = this.state.rows;
        let header_columns = ["Date"];
        rows.map((row) => {
            Object.keys(row).map((key) => {
                if (key.indexOf('date') === -1) {
                    let service_id = parseInt(key.replace('value_', ''));
                    let column_name = this.getServiceLabelByID(service_id);
                    if (!SUtils.in_array(column_name, header_columns))
                        header_columns.push(column_name);
                }
            });
        });
        return header_columns;
    };

    buildQuery = (type) => {
        //todo make some query builder
        let query = '/' + type + '?service_id=' + this.state.services_selected.join(',') + '&stat_type_id=' + this.state.stat_selected;
        if (this.state.date_from)
            query += '&date_from=' + this.state.date_from;
        if (this.state.date_to)
            query += '&date_to=' + this.state.date_to;
        return query;
    };

    exportCSV = () => {
        const query = this.buildQuery('csv_data.csv');
        const response = {file: query};
        window.location.href = response.file;
    };

    toggleToolbars = () => this.setState({toolbars_visible: !this.state.toolbars_visible});
    toggleAppBar = () => {
        this.setState({
            app_bar_expanded: !this.state.app_bar_expanded,
            app_bar_visibility: this.state.app_bar_expanded ? SHOW : HIDE
        });
    };

    serviceSelectorRenderer = (values) => {
        switch (values.length) {
            case 0:
                return 'Select services';
            default:
                let labels_array = [];
                values.map((val) => labels_array.push(this.getServiceLabelByID(val)));
                return labels_array.join(', ');
        }
    };

    serviceSelectorChanged = (event, index, values) => {
        if (values.length !== 0)
            this.setState({services_selected: values}, this.renewTable());
        else return false;
    };

    serviceItems = (services) => {
        return services.map((service) => (
            <MenuItem
                key={service.id}
                insetChildren={true}
                checked={this.state.services_selected.indexOf(service.id) > -1}
                value={service.id}
                primaryText={service.label}
            />
        ));
    };

    waiter_handler = (on_or_off) => this.setState({waiter_enabled: on_or_off});

    render() {
        return (
            <MuiThemeProvider>
                <div>
                    <Waiter enabled={this.state.waiter_enabled}/>
                    <AppBar
                        onLeftIconButtonTouchTap={this.toggleDrawer}
                        title="StatMaster"
                        iconElementRight={this.state.app_bar_expanded ? <ExpandMore style={EXPAND_STYLE}/> :
                            <ExpandLess style={EXPAND_STYLE}/>}
                        onRightIconButtonTouchTap={this.toggleAppBar}
                    />
                    <Drawer
                        docked={false}
                        open={this.state.drawer_open}
                        onRequestChange={(drawer_open) => this.setState({drawer_open})}>
                        <Paper>
                            <a href="/">
                                <MenuItem primaryText="Stats"/>
                            </a>
                            <MenuItem primaryText="Settings (in work)" disabled={true}/>
                            {/*<Menu value={this.state.service_selected} onChange={this.menuChanged}>*/}
                            {/*{this.props.all_services.map((service, i) =>*/}
                            {/*<MenuItem value={service.id}*/}
                            {/*checked={service.id === this.state.service_selected}*/}
                            {/*key={sKey('st')}>{service.label}*/}
                            {/*</MenuItem>*/}
                            {/*)}*/}
                            {/*</Menu>*/}
                        </Paper>
                    </Drawer>
                    <Card>
                        <div style={this.state.app_bar_visibility}>
                            <CardTitle title="Select services"/>
                            <div style={{marginLeft: '17px'}}>
                                <SelectField
                                    multiple={true}
                                    hintText="Select services"
                                    value={this.state.services_selected}
                                    onChange={this.serviceSelectorChanged}
                                    selectionRenderer={this.serviceSelectorRenderer}
                                    autoWidth={true}
                                >
                                    {this.serviceItems(this.props.all_services)}
                                </SelectField>
                            </div>
                            <CardText>
                                Services selected: {this.state.services_selected.map((service, i) =>
                                <div key={sKey('st')}><b>{this.getServiceLabelByID(service)}</b></div>
                            )}
                                <br/>
                                Select service from main menu, stat type and date interval below if needed.
                            </CardText>
                            <Toolbar>
                                <ToolbarGroup>
                                    <ToolbarTitle text="Parameters"/>
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
                                    <DatePicker key={sKey('st')} value={this.state.date_to}
                                                onChange={this.dateToChanged}
                                                hintText="To" mode="landscape"/>
                                </ToolbarGroup>

                                <ToolbarGroup>
                                    <RaisedButton
                                        label="Download csv"
                                        labelPosition="before"
                                        primary={true}
                                        onClick={this.exportCSV}
                                        icon={<FileDownload/>}
                                    />
                                </ToolbarGroup>
                            </Toolbar>
                            <Toolbar>
                                <div style={{display: 'flex'}}>
                                    <div>
                                        <ToolbarGroup>
                                            <Toggle onToggle={this.metricToggleChanged} label="Yandex Metrika"/>
                                        </ToolbarGroup>
                                    </div>
                                    <div style={METRIC_STYLES}>
                                        <ToolbarGroup style={this.state.metric_visibility}>
                                            <SelectField
                                                autoWidth={true}
                                                hintText="Type"
                                                value={this.state.metric_selected}
                                                onChange={this.handleMetricSelectChange}
                                            >
                                                <MenuItem key={sKey('st')} value={null} primaryText=""/>
                                                {Object.keys(this.state.metrics).map((metric, i) =>
                                                    <MenuItem key={sKey('st')} value={metric} primaryText={metric}/>
                                                )}
                                            </SelectField>
                                        </ToolbarGroup>
                                    </div>
                                </div>
                            </Toolbar>
                            <Toolbar>
                                <ToolbarGroup>
                                    <Toggle onToggle={this.commitsDataToggle} label="Commits data"/>
                                </ToolbarGroup>
                            </Toolbar>
                        </div>
                        <Tabs>
                            <Tab label="Table">
                                <Table>
                                    <TableHeader>
                                        <TableRow key={sKey('st')}>
                                            {this.state.table_header.map((type, i) =>
                                                <TableHeaderColumn key={sKey('st')}>{type}</TableHeaderColumn>
                                            )}
                                        </TableRow>
                                    </TableHeader>
                                    <TableBody>
                                        {this.state.rows.map((type, i) =>
                                            <TableRow key={sKey('st')}>
                                                {Object.keys(type).map((column, i) =>
                                                    <TableRowColumn key={sKey('st')}>{type[column]}</TableRowColumn>
                                                )}
                                            </TableRow>
                                        )}
                                    </TableBody>
                                </Table>
                                <div style={{display: 'flex', justifyContent: 'center'}}>
                                    <CircularProgress style={this.state.progress_style} size={100}/>
                                </div>
                            </Tab>
                            <Tab label="Graph">
                                <LineGraph data={this.state.rows}
                                           metric_enabled={this.state.metric_active}
                                           metric_selected={this.state.metric_selected}
                                           services_selected={this.state.services_selected}
                                           commits_data_enabled={this.state.commits_data_enabled}
                                           commits_data_visibility={this.state.commits_data_visibility}
                                           services_selected_with_labels={this.getSelectedServicesWithLabels()}
                                           waiter_handler={this.waiter_handler}
                                />
                            </Tab>
                        </Tabs>
                    </Card>
                </div>
            </MuiThemeProvider>
        );
    }
}