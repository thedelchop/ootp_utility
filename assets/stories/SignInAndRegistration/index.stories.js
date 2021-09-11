
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'SignInAndRegistration',
  decorators: [centerScreen]
};

export const SimpleCard = () => require('./simple_card.html')

export const SimpleNoLabels = () => require('./simple_no_labels.html')

export const SplitScreen = () => require('./split_screen.html')
      