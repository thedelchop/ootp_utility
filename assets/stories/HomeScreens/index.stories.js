
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'HomeScreens',
  decorators: [centerScreen]
};

export const FullWidthWithSidebar = () => require('./full_width_with_sidebar.html')

export const CardLayoutWithSidebar = () => require('./card_layout_with_sidebar.html')

export const ConstrainedMultiColumn = () => require('./constrained_multi_column.html')

export const ConstrainedGridLayout = () => require('./constrained_grid_layout.html')

export const WithSecondaryNavAndTertiaryColumn = () => require('./with_secondary_nav_and_tertiary_column.html')
      