
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'RadioGroups',
  decorators: [centerScreen]
};

export const StackedCards = () => require('./stacked_cards.html')

export const ListWithDescription = () => require('./list_with_description.html')

export const SimpleTable = () => require('./simple_table.html')
      