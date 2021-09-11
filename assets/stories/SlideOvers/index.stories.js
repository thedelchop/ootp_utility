
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'SlideOvers',
  decorators: [centerScreen]
};

export const Empty = () => require('./empty.html')

export const WideEmpty = () => require('./wide_empty.html')

export const WithBackgroundOverlay = () => require('./with_background_overlay.html')

export const WithCloseButtonOnOutside = () => require('./with_close_button_on_outside.html')

export const WithBrandedHeader = () => require('./with_branded_header.html')

export const WithStickyFooter = () => require('./with_sticky_footer.html')

export const CreateProjectFormExample = () => require('./create_project_form_example.html')

export const WideCreateProjectFormExample = () => require('./wide_create_project_form_example.html')

export const UserProfileExample = () => require('./user_profile_example.html')

export const WideHorizontalUserProfileExample = () => require('./wide_horizontal_user_profile_example.html')

export const ContactListExample = () => require('./contact_list_example.html')

export const FileDetailsExample = () => require('./file_details_example.html')
      