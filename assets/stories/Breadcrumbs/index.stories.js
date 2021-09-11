
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Breadcrumbs',
  decorators: [centerScreen]
};

export const Contained = () => require('./contained.html')

export const FullWidthBar = () => require('./full_width_bar.html')

export const SimpleWithChevrons = () => require('./simple_with_chevrons.html')

export const SimpleWithSlashes = () => require('./simple_with_slashes.html')
      