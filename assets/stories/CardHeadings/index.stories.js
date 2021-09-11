
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'CardHeadings',
  decorators: [centerScreen]
};

export const Simple = () => require('./simple.html')

export const WithAction = () => require('./with_action.html')

export const WithAvatarAndActions = () => require('./with_avatar_and_actions.html')

export const WithDescriptionAndAction = () => require('./with_description_and_action.html')

export const WithDescription = () => require('./with_description.html')

export const WithAvatarMetaAndDropdown = () => require('./with_avatar_meta_and_dropdown.html')
      