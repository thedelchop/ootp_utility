
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Feeds',
  decorators: [centerScreen]
};

export const SimpleWithIcons = () => require('./simple_with_icons.html')

export const StackedWithAvatars = () => require('./stacked_with_avatars.html')

export const WithMultipleItemTypes = () => require('./with_multiple_item_types.html')
      