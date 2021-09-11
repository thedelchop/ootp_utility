
import {centerScreen} from "../../.storybook/decorators";

export default {
  title: 'DetailScreens',
  decorators: [centerScreen]
};

export const MultiColumnDirectory = () => require('./multi_column_directory.html')

export const StackedCardLayout = () => require('./stacked_card_layout.html')

export const ConstrainedWithSidebar = () => require('./constrained_with_sidebar.html')

export const MultiColumnInbox = () => require('./multi_column_inbox.html')

export const FileGallery = () => require('./file_gallery.html')

export const WithPageHeadingAndStackedList = () => require('./with_page_heading_and_stacked_list.html')
      