import React from 'react';
import Waiter from 'material-ui/CircularProgress';

const STYLES = {
    position: 'fixed',
    alignItems: 'center',
    justifyContent: 'center',
    height: '100%',
    padding: '0',
    margin: '0',
    width: '100%',
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    zIndex: '1'
};
const ON = {display: 'flex'};
const OFF = {display: 'none'};

export default class LineGraph extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            enabled: props.enabled,
            waiter_styles: this.off_styles()
        };
    }

    componentWillReceiveProps(nextProps) {
        if (this.state.enabled !== nextProps.enabled)
            this.setState({
                enabled: nextProps.enabled,
                waiter_styles: nextProps.enabled ? this.on_styles() : this.off_styles()
            });
    }

    on_styles = () => Object.assign({}, STYLES, ON);
    off_styles = () => Object.assign({}, STYLES, OFF);

    render() {
        return (
            <div style={this.state.waiter_styles}>
                <Waiter size={200}/>
            </div>
        )
    }
}