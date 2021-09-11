
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Pagination',
  decorators: [centerScreen]
};

export const CardFooterWithPageButtons = () => require('./card_footer_with_page_buttons.html')

export const CenteredPageNumbers = () => require('./centered_page_numbers.html')

export const SimpleCardFooter = () => require('./simple_card_footer.html')
      