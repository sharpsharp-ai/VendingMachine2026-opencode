package de.sharpsharp.gildedrose;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

import org.junit.Test;

public class OrdinaryItemTest {

    @Test
    public void anItemKeepsItsName() {
        Item foo = new Item("foo", 0, 0);
        GildedRose.with(foo).updateQuality();
        assertThat(foo.getName(), is("foo"));
    }

    @Test
    public void ordinaryItemLosesOneQualityBeforeTheSellDate() {
        Item item = new Item("foo", 1, 1);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(0));
        assertThat(item.getSellIn(), is(0));
    }

    @Test
    public void ordinaryItemAtZeroQualityStaysAtZero() {
        Item item = new Item("foo", 0, 0);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(0));
        assertThat(item.getSellIn(), is(-1));
    }

    @Test
    public void ordinaryItemLosesTwoQualityAfterTheSellDate() {
        Item item = new Item("foo", 0, 2);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(0));
        assertThat(item.getSellIn(), is(-1));
    }
}
