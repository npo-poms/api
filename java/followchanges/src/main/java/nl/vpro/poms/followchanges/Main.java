package nl.vpro.poms.followchanges;

import lombok.extern.slf4j.Slf4j;
import nl.vpro.api.client.frontend.NpoApiClients;
import nl.vpro.api.client.utils.NpoApiMediaUtil;
import nl.vpro.domain.api.Deletes;
import nl.vpro.domain.api.MediaChange;
import nl.vpro.domain.api.Order;
import nl.vpro.domain.api.Tail;
import nl.vpro.util.CountedIterator;
import nl.vpro.util.Env;

import java.io.FileDescriptor;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.time.Duration;
import java.time.Instant;

import static java.nio.charset.StandardCharsets.UTF_8;
import static nl.vpro.util.Env.PROD;

/**
 * @author Michiel Meeuwissen
 * @since ...
 */
@Slf4j
public class Main {



    public static void main(String[] argv) throws InterruptedException {
        System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out), true, UTF_8));


        NpoApiClients clients = NpoApiClients
            .configured(argv.length > 0 ? Env.valueOf(argv[0].toUpperCase()) : PROD)
            .build();
        NpoApiMediaUtil mediaUtil = NpoApiMediaUtil.builder()
            .clients(clients)
            .build();
        Instant start = Instant.now().minus(Duration.ofMinutes(10));
        String mid = null;
        int call = 0;
        while(true) {

            try (CountedIterator<MediaChange> changes = mediaUtil.changes(null, false, start, mid, Order.ASC, null, Deletes.ID_ONLY, Tail.ALWAYS))  {
                while (changes.hasNext()) {
                    MediaChange change = changes.next();
                    log.info(call + ":" + change);
                    start = change.getPublishDate();
                    mid = change.getMid();
                }
            } catch (Exception e) {
                log.info(e.getMessage());
            }
            call++;
            Thread.sleep(1000L);
        }

    }
}
