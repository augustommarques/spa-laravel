<template>
    <Link :href="route('posts')">Posts</Link>
    <div>
        <h1>Test</h1>
    </div>
</template>

<script>
import { Link } from '@inertiajs/inertia-vue3';
export default {
    name: 'Test',
    components: {
        Link,
    },
};
</script>