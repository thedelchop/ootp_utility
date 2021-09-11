
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Checkboxes',
  decorators: [centerScreen]
};

export const ListWithDescription = () => require('./list_with_description.html')

export const ListWithInlineDescription = () => require('./list_with_inline_description.html')

export const ListWithCheckboxOnRight = () => require('./list_with_checkbox_on_right.html')

export const SimpleListWithHeading = () => require('./simple_list_with_heading.html')
      