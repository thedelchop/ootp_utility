
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'InputGroups',
  decorators: [centerScreen]
};

export const InputWithLabel = () => require('./input_with_label.html')

export const InputWithLabelAndHelpText = () => require('./input_with_label_and_help_text.html')

export const InputWithValidationError = () => require('./input_with_validation_error.html')

export const InputWithHiddenLabel = () => require('./input_with_hidden_label.html')

export const InputWithCornerHint = () => require('./input_with_corner_hint.html')

export const InputWithLeadingIcon = () => require('./input_with_leading_icon.html')

export const InputWithTrailingIcon = () => require('./input_with_trailing_icon.html')

export const InputWithAddOn = () => require('./input_with_add_on.html')

export const InputWithInlineAddOn = () => require('./input_with_inline_add_on.html')

export const InputWithInlineLeadingAndTrailingAddOns = () => require('./input_with_inline_leading_and_trailing_add_ons.html')

export const InputWithInlineLeadingDropdown = () => require('./input_with_inline_leading_dropdown.html')

export const InputWithInlineLeadingAddOnAndTrailingDropdown = () => require('./input_with_inline_leading_add_on_and_trailing_dropdown.html')

export const InputWithLeadingIconAndTrailingButton = () => require('./input_with_leading_icon_and_trailing_button.html')

export const InputsWithSharedBorders = () => require('./inputs_with_shared_borders.html')

export const InputWithInsetLabel = () => require('./input_with_inset_label.html')

export const InputsWithInsetLabelsAndSharedBorders = () => require('./inputs_with_inset_labels_and_shared_borders.html')

export const InputWithOverlappingLabel = () => require('./input_with_overlapping_label.html')

export const InputWithPillShape = () => require('./input_with_pill_shape.html')

export const InputWithGrayBackgroundAndBottomBorder = () => require('./input_with_gray_background_and_bottom_border.html')

export const InputWithKeyboardShortcut = () => require('./input_with_keyboard_shortcut.html')
      