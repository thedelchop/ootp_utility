
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Notifications',
  decorators: [centerScreen]
};

export const Simple = () => require('./simple.html')

export const Condensed = () => require('./condensed.html')

export const WithActionsBelow = () => require('./with_actions_below.html')

export const WithAvatar = () => require('./with_avatar.html')

export const WithSplitButtons = () => require('./with_split_buttons.html')

export const WithButtonsBelow = () => require('./with_buttons_below.html')
      