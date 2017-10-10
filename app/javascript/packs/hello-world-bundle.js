import ReactOnRails from 'react-on-rails';

import HelloWorld from '../bundles/HelloWorld/components/HelloWorld';
import LolButton from '../bundles/HelloWorld/components/LolButton';
import StatTable from '../bundles/HelloWorld/components/StatTable';

// This is how react_on_rails can see the HelloWorld in the browser.
ReactOnRails.register({
  HelloWorld,
  LolButton,
  StatTable
});
