
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'SelectMenus',
  decorators: [centerScreen]
};

export const SimpleNative = () => require('./simple_native.html')

export const SimpleCustom = () => require('./simple_custom.html')

export const CustomWithCheckOnLeft = () => require('./custom_with_check_on_left.html')

export const CustomWithStatusIndicator = () => require('./custom_with_status_indicator.html')

export const CustomWithAvatar = () => require('./custom_with_avatar.html')

export const WithSecondaryText = () => require('./with_secondary_text.html')

export const BrandedWithSupportedText = () => require('./branded_with_supported_text.html')
      