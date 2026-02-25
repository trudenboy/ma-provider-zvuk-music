// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://trudenboy.github.io/ma-provider-zvuk-music',
	base: '/ma-provider-zvuk-music',
	integrations: [
		starlight({
			title: 'Zvuk Music · MA Provider',
			locales: {
				root: { label: 'Русский', lang: 'ru' },
				en: { label: 'English', lang: 'en' },
			},
			defaultLocale: 'root',
			editLink: {
				baseUrl: 'https://github.com/trudenboy/ma-provider-zvuk-music/edit/dev/docs-site/src/content/docs/',
			},
			social: [
				{ icon: 'github', label: 'GitHub', href: 'https://github.com/trudenboy/ma-provider-zvuk-music' },
			],
			sidebar: [
				{ label: 'Главная / Home', translations: { en: 'Home' }, slug: 'index' },
				{ label: 'Настройка', translations: { en: 'Configuration' }, slug: 'configuration' },
				{ label: 'Известные проблемы', translations: { en: 'Known Issues' }, slug: 'known-issues' },
				{
					label: 'Разработка',
					translations: { en: 'Development' },
					items: [
						{ label: 'Окружение', translations: { en: 'Dev Environment' }, slug: 'development' },
						{ label: 'Docker', slug: 'dev-docker' },
						{ label: 'Тестирование', translations: { en: 'Testing' }, slug: 'testing' },
						{ label: 'Участие в разработке', translations: { en: 'Contributing' }, slug: 'contributing' },
						{ label: 'Управление инцидентами', translations: { en: 'Incident Management' }, slug: 'incident-management' },
					],
				},
			],
		}),
	],
});
