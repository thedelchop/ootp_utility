
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'ListContainers',
  decorators: [centerScreen]
};

export const SimpleWithDividers = () => require('./simple_with_dividers.html')

export const CardWithDividers = () => require('./card_with_dividers.html')

export const CardWithDividersFullWidthOnMobile = () => require('./card_with_dividers_full_width_on_mobile.html')

export const SeparateCards = () => require('./separate_cards.html')

export const SeparateCardsFullWidthOnMobile = () => require('./separate_cards_full_width_on_mobile.html')

export const FlatCardWithDividers = () => require('./flat_card_with_dividers.html')

export const SimpleWithDividersFullWidthOnMobile = () => require('./simple_with_dividers_full_width_on_mobile.html')
      