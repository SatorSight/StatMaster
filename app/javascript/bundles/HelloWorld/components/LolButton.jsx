import PropTypes from 'prop-types';
import React from 'react';
import RaisedButton from 'material-ui/RaisedButton';
import muiTheme from 'material-ui/styles/muiThemeable'
import getMuiTheme from 'material-ui/styles/getMuiTheme';
import {deepOrange500} from 'material-ui/styles/colors';

import { withStyles, MuiThemeProvider } from 'material-ui/styles';

export default class LolButton extends React.Component {

    /**
     * @param props - Comes from your rails view.
     */
    constructor(props) {
        super(props);

        this.state = { name: this.props.name };
    }

    render() {
        return (
            <MuiThemeProvider>
                <RaisedButton>
                    Hello World
                </RaisedButton>
            </MuiThemeProvider>
        );
    }

}
//
//
// function App() {
//     return (
//         <Button>
//             Hello World
//         </Button>
//     );
// }
//
// render(<App />, document.querySelector('#app'));