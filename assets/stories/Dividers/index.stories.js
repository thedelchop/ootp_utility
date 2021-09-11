
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Dividers',
  decorators: [centerScreen]
};

export const WithLabel = () => require('./with_label.html')

export const WithIcon = () => require('./with_icon.html')

export const WithLabelOnLeft = () => require('./with_label_on_left.html')

export const WithTitle = () => require('./with_title.html')

export const WithTitleOnLeft = () => require('./with_title_on_left.html')

export const WithButton = () => require('./with_button.html')

export const WithTitleAndButton = () => require('./with_title_and_button.html')

export const WithToolbar = () => require('./with_toolbar.html')
      