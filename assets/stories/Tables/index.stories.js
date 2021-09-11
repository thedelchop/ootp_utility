
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'Tables',
  decorators: [centerScreen]
};

export const SimpleStriped = () => require('./simple_striped.html')

export const Simple = () => require('./simple.html')

export const WithAvatarsAndMultiLineContent = () => require('./with_avatars_and_multi_line_content.html')
      