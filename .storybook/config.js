import { configure } from '@storybook/react';

configure(require.context('../assets/js/', true, /\.stories\.tsx$/), module);
