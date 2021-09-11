
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'MultiColumnLayouts',
  decorators: [centerScreen]
};

export const FullWidthThreeColumn = () => require('./full_width_three_column.html')

export const FullWidthSecondaryColumnOnRight = () => require('./full_width_secondary_column_on_right.html')

export const ConstrainedThreeColumn = () => require('./constrained_three_column.html')

export const ConstrainedWithStickyColumns = () => require('./constrained_with_sticky_columns.html')

export const FullWidthWithNarrowSidebar = () => require('./full_width_with_narrow_sidebar.html')

export const FullWidthWithNarrowSidebarAndSecondaryColumnOnRight = () => require('./full_width_with_narrow_sidebar_and_secondary_column_on_right.html')

export const FullWidthWithNarrowBrandedSidebar = () => require('./full_width_with_narrow_branded_sidebar.html')
      