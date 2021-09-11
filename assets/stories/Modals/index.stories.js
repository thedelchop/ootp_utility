
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Modals',
  decorators: [centerScreen]
};

export const CenteredWithSingleAction = () => require('./centered_with_single_action.html')

export const CenteredWithWideButtons = () => require('./centered_with_wide_buttons.html')

export const SimpleAlert = () => require('./simple_alert.html')

export const SimpleWithDismissButton = () => require('./simple_with_dismiss_button.html')

export const SimpleWithGrayFooter = () => require('./simple_with_gray_footer.html')

export const SimpleAlertWithLeftAlignedButtons = () => require('./simple_alert_with_left_aligned_buttons.html')
      