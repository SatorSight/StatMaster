import React from 'react';

import MenuItem from 'material-ui/MenuItem';
import AppBar from 'material-ui/AppBar';
import Drawer from 'material-ui/Drawer';
import Paper from 'material-ui/Paper';
import {GridList} from 'material-ui/GridList';
import Checkbox from 'material-ui/Checkbox';
import {Card, CardTitle} from 'material-ui/Card';
import Waiter from './Waiter'

import {withStyles, MuiThemeProvider} from 'material-ui/styles';
import sKey from './sKey';
import * as SUtils from './SUtils';

const SHOW = {display: 'block'};
const HIDE = {display: 'none'};

export default class Settings extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            drawer_open: false,
            progress_style: HIDE,
            toolbars_visible: true,
            app_bar_expanded: false,
            app_bar_visibility: SHOW,
            waiter_enabled: false,
            all_services: props.all_services,
        };
    }

    getServiceByID = (id) => {
        let serv = null;
        this.state.all_services.map((service) => {
            if (service.id === id)
                serv = service;
        });
        return serv;
    };

    toggleDrawer = () => this.setState({drawer_open: !this.state.drawer_open});

    updateServiceStats = (service, callback) => {
        const new_services = this.state.all_services.map((serv) => serv.id === service.id ? service : serv);
        this.setState({all_services: new_services}, callback);
    };

    changeStatsForService = (service_id, stat_id, callback) => {
        let service = this.getServiceByID(service_id);
        service.stat_types = SUtils.toggle_array_element(stat_id, service.stat_types);
        this.updateServiceStats(service, callback);
    };


    isStatEnabled = (service, stat) => SUtils.in_array(stat, service.stat_types);
    serviceStatChange = (event, isInputChecked) => {
        const arr = event.target.value.split(',');
        const service_id = Number(arr[0]);
        const stat_id = Number(arr[1]);
        const set_to = isInputChecked ? 'enable' : 'disable';

        this.changeStatsForService(service_id, stat_id, function () {
            const query = '/set_stat?service_id=' + service_id + '&stat_id=' + stat_id + '&set_to=' + set_to;
            fetch(query);
        });
    };

    allStatsEnabled = () => {
        let enabled = true;
        const stats_count = this.props.stat_types.length;
        this.state.all_services.map((service) => {
            if (service.stat_types.length !== stats_count)
                enabled = false;
        });
        return enabled;
    };

    render() {
        return (
            <MuiThemeProvider>
                <div>
                    <Waiter enabled={this.state.waiter_enabled}/>
                    <AppBar
                        onLeftIconButtonTouchTap={this.toggleDrawer}
                        title="StatMaster"
                    />
                    <Drawer
                        docked={false}
                        open={this.state.drawer_open}
                        onRequestChange={(drawer_open) => this.setState({drawer_open})}>
                        <Paper>
                            <a href="/">
                                <MenuItem key={sKey('ss')} primaryText="Stats"/>
                            </a>
                            <a href="/settings">
                                <MenuItem key={sKey('ss')} primaryText="Settings"/>
                            </a>
                        </Paper>
                    </Drawer>
                    <Card>
                        <div style={{
                            display: 'flex',
                            flexWrap: 'wrap',
                            justifyContent: 'center'
                        }}>
                            <CardTitle title="Select stats for services"/>
                            {this.allStatsEnabled() ? <div style={{padding: '27px', color: 'green'}}>
                                All stats operational
                            </div> : null}
                            <GridList cellHeight={'auto'}>
                                {this.state.all_services.map((service) => {
                                    return (
                                        <div key={sKey('ss')} style={{margin: '10px'}}>
                                            <h3 key={sKey('ss')}>{service.label}</h3>
                                            {this.props.stat_types.map((stat) => {
                                                const value = service.id + ',' + stat.id;
                                                return (<Checkbox
                                                    label={stat.title}
                                                    labelPosition="left"
                                                    key={sKey('ss')}
                                                    checked={this.isStatEnabled(service, stat.id)}
                                                    onCheck={this.serviceStatChange}
                                                    value={value}
                                                />)
                                            })}
                                        </div>
                                    )
                                })}
                            </GridList>
                        </div>
                    </Card>
                </div>
            </MuiThemeProvider>
        );
    }
}