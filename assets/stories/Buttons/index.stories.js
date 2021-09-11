
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Buttons',
  decorators: [centerScreen]
};

export const PrimaryButtons = () => require('./primary_buttons.html')

export const SecondaryButtons = () => require('./secondary_buttons.html')

export const WhiteButtons = () => require('./white_buttons.html')

export const ButtonWithLeadingIcon = () => require('./button_with_leading_icon.html')

export const ButtonWithTrailingIcons = () => require('./button_with_trailing_icons.html')

export const RoundButtons = () => require('./round_buttons.html')

export const CircularButtons = () => require('./circular_buttons.html')
      