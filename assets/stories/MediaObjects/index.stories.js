
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'MediaObjects',
  decorators: [centerScreen]
};

export const Basic = () => require('./basic.html')

export const AlignedToCenter = () => require('./aligned_to_center.html')

export const AlignedToBottom = () => require('./aligned_to_bottom.html')

export const StretchedToFit = () => require('./stretched_to_fit.html')

export const MediaOnRight = () => require('./media_on_right.html')

export const BasicResponsive = () => require('./basic_responsive.html')

export const WideResponsive = () => require('./wide_responsive.html')

export const Nested = () => require('./nested.html')
      