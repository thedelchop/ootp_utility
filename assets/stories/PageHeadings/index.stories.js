
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'PageHeadings',
  decorators: [centerScreen]
};

export const WithActions = () => require('./with_actions.html')

export const WithActionsOnDark = () => require('./with_actions_on_dark.html')

export const WithActionsAndBreadcrumbs = () => require('./with_actions_and_breadcrumbs.html')

export const WithActionsAndBreadcrumbsOnDark = () => require('./with_actions_and_breadcrumbs_on_dark.html')

export const WithMetaAndActions = () => require('./with_meta_and_actions.html')

export const WithMetaAndActionsOnDark = () => require('./with_meta_and_actions_on_dark.html')

export const WithBannerImage = () => require('./with_banner_image.html')

export const WithAvatarAndActions = () => require('./with_avatar_and_actions.html')

export const CardWithAvatarAndStats = () => require('./card_with_avatar_and_stats.html')

export const WithMetaActionsAndBreadcrumbs = () => require('./with_meta_actions_and_breadcrumbs.html')

export const WithMetaActionsAndBreadcrumbsOnDark = () => require('./with_meta_actions_and_breadcrumbs_on_dark.html')
      