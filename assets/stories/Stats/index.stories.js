
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Stats',
  decorators: [centerScreen]
};

export const Simple = () => require('./simple.html')

export const WithBrandIcon = () => require('./with_brand_icon.html')

export const WithSharedBorders = () => require('./with_shared_borders.html')
      