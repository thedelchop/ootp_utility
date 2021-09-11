
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Dropdowns',
  decorators: [centerScreen]
};

export const Simple = () => require('./simple.html')

export const WithDividers = () => require('./with_dividers.html')

export const WithIcons = () => require('./with_icons.html')

export const WithMinimalMenuIcon = () => require('./with_minimal_menu_icon.html')

export const WithSimpleHeader = () => require('./with_simple_header.html')
      