
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'SectionHeadings',
  decorators: [centerScreen]
};

export const Simple = () => require('./simple.html')

export const WithDescription = () => require('./with_description.html')

export const WithActions = () => require('./with_actions.html')

export const WithAction = () => require('./with_action.html')

export const WithInputGroup = () => require('./with_input_group.html')

export const WithTabs = () => require('./with_tabs.html')

export const WithActionsAndTabs = () => require('./with_actions_and_tabs.html')

export const WithInlineTabs = () => require('./with_inline_tabs.html')

export const WithLabel = () => require('./with_label.html')

export const WithBadgeAndDropdown = () => require('./with_badge_and_dropdown.html')
      