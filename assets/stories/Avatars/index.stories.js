
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Avatars',
  decorators: [centerScreen]
};

export const CircularAvatars = () => require('./circular_avatars.html')

export const RoundedAvatars = () => require('./rounded_avatars.html')

export const CircularAvatarsWithTopNotification = () => require('./circular_avatars_with_top_notification.html')

export const RoundedAvatarsWithTopNotification = () => require('./rounded_avatars_with_top_notification.html')

export const CircularAvatarsWithBottomNotification = () => require('./circular_avatars_with_bottom_notification.html')

export const RoundedAvatarsWithBottomNotification = () => require('./rounded_avatars_with_bottom_notification.html')

export const CircularAvatarsWithPlaceholderIcon = () => require('./circular_avatars_with_placeholder_icon.html')

export const CircularAvatarsWithPlaceholderInitials = () => require('./circular_avatars_with_placeholder_initials.html')

export const AvatarGroupStackedBottomToTop = () => require('./avatar_group_stacked_bottom_to_top.html')

export const AvatarGroupStackedTopToBottom = () => require('./avatar_group_stacked_top_to_bottom.html')

export const WithText = () => require('./with_text.html')
      