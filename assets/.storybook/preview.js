import { addParameters } from '@storybook/client-api';
import { INITIAL_VIEWPORTS } from '@storybook/addon-viewport';

addParameters({
    viewport: {
        viewports: INITIAL_VIEWPORTS,
    },
});

import '../css/storybook.css'
import '../js/storybook'
