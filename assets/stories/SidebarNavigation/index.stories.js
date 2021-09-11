
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'SidebarNavigation',
  decorators: [centerScreen]
};

export const BrandWithIconsBadgesAndProfileSection = () => require('./brand_with_icons_badges_and_profile_section.html')

export const DarkWithIconsBadgesAndProfileSection = () => require('./dark_with_icons_badges_and_profile_section.html')

export const SimpleWithIconsAndBadges = () => require('./simple_with_icons_and_badges.html')

export const SimpleWithIconsAndBrandColor = () => require('./simple_with_icons_and_brand_color.html')

export const SimpleWithIconsBadgesAndProfileSection = () => require('./simple_with_icons_badges_and_profile_section.html')

export const WithExpandableSections = () => require('./with_expandable_sections.html')

export const WithIconsAndExpandableSections = () => require('./with_icons_and_expandable_sections.html')

export const WithSecondaryNavigation = () => require('./with_secondary_navigation.html')
      