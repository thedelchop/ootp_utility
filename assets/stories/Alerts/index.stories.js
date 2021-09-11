
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Alerts',
  decorators: [centerScreen]
};

export const WithDescription = () => require('./with_description.html')

export const WithList = () => require('./with_list.html')

export const WithActions = () => require('./with_actions.html')

export const WithLinkOnRight = () => require('./with_link_on_right.html')

export const WithAccentBorder = () => require('./with_accent_border.html')

export const WithDismissButton = () => require('./with_dismiss_button.html')
      