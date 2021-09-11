
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Tabs',
  decorators: [centerScreen]
};

export const TabsWithUnderline = () => require('./tabs_with_underline.html')

export const TabsWithUnderlineAndIcons = () => require('./tabs_with_underline_and_icons.html')

export const TabsInPills = () => require('./tabs_in_pills.html')

export const TabsInPillsOnGray = () => require('./tabs_in_pills_on_gray.html')

export const TabsInPillsWithBrandColor = () => require('./tabs_in_pills_with_brand_color.html')

export const FullWidthTabsWithUnderline = () => require('./full_width_tabs_with_underline.html')

export const BarWithUnderline = () => require('./bar_with_underline.html')

export const TabsWithUnderlineAndBadges = () => require('./tabs_with_underline_and_badges.html')
      