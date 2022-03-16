<template>
    
    <Link :href="route('test')">Test</Link>
        <div>
            <br>
            <h1>Posts</h1>
            <ul>
                <li v-for="post in posts" :key="post.id">
                    <h2>{{ post.title }}</h2>
                    <p>{{ post.content }}</p>
                </li>
            </ul>
        </div>
</template>

<script>
import { Link } from '@inertiajs/inertia-vue3';
export default {
    name: 'Posts',
    components: {
        Link,
    },
    props: {
        posts: Array,
    },
};
</script>