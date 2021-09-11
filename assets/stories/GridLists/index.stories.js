
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'GridLists',
  decorators: [centerScreen]
};

export const ContactCardsWithSmallPortraits = () => require('./contact_cards_with_small_portraits.html')

export const ContactCards = () => require('./contact_cards.html')

export const SimpleCards = () => require('./simple_cards.html')

export const HorizontalLinkCards = () => require('./horizontal_link_cards.html')

export const ActionsWithSharedBorders = () => require('./actions_with_shared_borders.html')

export const ImagesWithDetails = () => require('./images_with_details.html')
      